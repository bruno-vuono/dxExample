@isTest
public class MMPJ_TOPG_MinutesPDFcontrollerTest
{
    private static  Datetime myDT = Datetime.now();
    private static String  mailPrefix = myDT.format('ddMMyyyy');
    static testMethod void testMinutesPDF()
    {  
        Profile adminProfile = [Select Id From Profile Where Name = 'System Administrator'];
        
        User u = new User(Username = mailPrefix+'-NPLsupervisor@pernod-ricard.com', email = mailPrefix+'-supervisor@pernod-ricard.com', profileID = adminProfile.id, IsActive = true, LastName='Supervisor', Alias='sup', TimeZoneSidKey='GMT', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US');
        insert u;
        User u2 = new User(Username = mailPrefix+'-NPLsuper2visor@pernod-ricard.com', email = mailPrefix+'-super2visor@pernod-ricard.com', profileID = adminProfile.id, IsActive = true, LastName='Supervisor', Alias='sup', TimeZoneSidKey='GMT', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US');
        insert u2;
        System.runAs(u){
            //create market 
            MMPJ_TOPG_Market__c market = new MMPJ_TOPG_Market__c();
            market.Name='testmarket';
            insert market;
            
            //create brand
            MMPJ_TOPG_BRAND__c brand = new MMPJ_TOPG_BRAND__c();
            brand.name='Martell';
            insert brand;
            
            MMPJ_TOPG_BMC__c bmcTest = new MMPJ_TOPG_BMC__c ();
            bmcTest.name='bmcTest';
            //BTO => BMC : delete "Brand & market"
           // bmcTest.MMPJ_TOPG_Market__c=market.id;
           // bmcTest.MMPJ_TOPG_Brand__c=brand.id;
            insert bmcTest ;
            
            MMPJ_TOPG_Meeting__c  meeting = new MMPJ_TOPG_Meeting__c ();
            meeting.MMPJ_TOPG_BMC__c = bmcTest.id;
            Meeting.MMPJ_TOPG_Interaction__c = 'test';
            insert meeting;
            
            Event ev = new Event();
            ev.Subject='tet';
            ev.StartDateTime = DateTime.parse('2/2/2016 10:53 AM') ;
            ev.ENDDateTime = DateTime.parse('2/2/2016 10:55 AM');
            ev.Location = 'est';
            ev.Whatid=meeting.id;
            insert ev;
            
            eventRelation evRl = new EventRelation();
            evRl.relationid = u2.id;
            evRl.EventId = ev.id;
            insert evRl;
            
            contact c = new contact();
            c.Lastname = 'test contact';
            insert c;
            
            eventRelation evRl2 = new EventRelation();
            evRl2.relationid = c.id;
            evRl2.EventId = ev.id;
            insert evRl2;
            
			MMPJ_TOPG_MeetingProject__c project = new MMPJ_TOPG_MeetingProject__c();
			//project.MMPJ_TOPG_Market__c = 'Market'; 
			//project.MMPJ_TOPG_ProjectTopic__c = 'Product Launch';
			insert project;
			
			
            MMPJ_TOPG_MinuteOfMeeting__c Mom = new MMPJ_TOPG_MinuteOfMeeting__c();
            Mom.MMPJ_TOPG_Meeting__c = meeting.Id;
            mom.MMPJ_TOPG_Title__c='Test pdf';
            insert Mom;
            MMPJ_TOPG_MoMLineItem__c MomLine = new MMPJ_TOPG_MoMLineItem__c();
            MomLine.MMPJ_TOPG_Title__c ='test Line 1';
            MomLine.MMPJ_TOPG_MinutesofMeeting__c  = Mom.id;
			MomLine.MMPJ_TOPG_IsHighlight__c = true;
			MomLine.MMPJ_TOPG_TopicPPPP__c = 'Product';
			MomLine.MMPJ_TOPG_Comment__c = 'Comment';
            insert MomLine;
			MMPJ_TOPG_MoMLineItem__c MomLine2 = new MMPJ_TOPG_MoMLineItem__c();
            MomLine2.MMPJ_TOPG_Title__c ='test Line 2';
            MomLine2.MMPJ_TOPG_MinutesofMeeting__c  = Mom.id;
			MomLine2.MMPJ_TOPG_IsHighlight__c = true;
			MomLine2.MMPJ_TOPG_Detail_Line_Topic__c = 'Market Performance';
			MomLine2.MMPJ_TOPG_Comment__c = 'Comment';
            insert MomLine2;
			MMPJ_TOPG_MoMLineItem__c MomLine3 = new MMPJ_TOPG_MoMLineItem__c();
            MomLine3.MMPJ_TOPG_Title__c ='test Line 3';
            MomLine3.MMPJ_TOPG_MinutesofMeeting__c  = Mom.id;
			MomLine3.MMPJ_TOPG_IsHighlight__c = false;
			MomLine3.MMPJ_TOPG_Comment__c = 'Comment';
            insert MomLine3;
			MMPJ_TOPG_MoMLineItem__c MomLine4 = new MMPJ_TOPG_MoMLineItem__c();
            MomLine4.MMPJ_TOPG_Title__c ='test Line 4';
            MomLine4.MMPJ_TOPG_MinutesofMeeting__c  = Mom.id;
			MomLine4.MMPJ_TOPG_IsHighlight__c = false;
			MomLine4.MMPJ_TOPG_Comment__c = 'Comment';
            insert MomLine4;
			MMPJ_TOPG_MoMLineItem__c MomLine5 = new MMPJ_TOPG_MoMLineItem__c();
            MomLine5.MMPJ_TOPG_Title__c ='test Line 5';
            MomLine5.MMPJ_TOPG_MinutesofMeeting__c  = Mom.id;
			MomLine5.MMPJ_TOPG_IsHighlight__c = true;
			MomLine5.MMPJ_TOPG_Comment__c = 'Comment';
            insert MomLine5;
			MMPJ_TOPG_MoMLineItem__c MomLine8 = new MMPJ_TOPG_MoMLineItem__c();
            MomLine8.MMPJ_TOPG_Title__c ='test Line 8';
            MomLine8.MMPJ_TOPG_MinutesofMeeting__c  = Mom.id;
			MomLine8.MMPJ_TOPG_IsHighlight__c = false;
			MomLine8.MMPJ_TOPG_Detail_Line_Topic__c = 'Market Performance';
			MomLine8.MMPJ_TOPG_Comment__c = 'Comment';
            insert MomLine8;
            Test.setCurrentPageReference(Page.MMPJ_TOPG_MinutesPDF);
            System.currentPageReference().getParameters().put('EventId', ev.id);
            System.currentPageReference().getParameters().put('MeetingId', meeting.id);
            MMPJ_TOPG_MinutesPDFcontroller Ctrl = new MMPJ_TOPG_MinutesPDFcontroller();
			
			
			MMPJ_TOPG_MinuteOfMeeting__c Mom2 = new MMPJ_TOPG_MinuteOfMeeting__c();
            Mom2.MMPJ_TOPG_Meeting__c = meeting.Id;
            Mom2.MMPJ_TOPG_Title__c='Test pdf';
            insert Mom2;
			MMPJ_TOPG_MoMLineItem__c MomLine6 = new MMPJ_TOPG_MoMLineItem__c();
            MomLine6.MMPJ_TOPG_Title__c ='test Line Market';
            MomLine6.MMPJ_TOPG_MinutesofMeeting__c  = Mom2.id;
			MomLine6.MMPJ_TOPG_IsHighlight__c = false;
			MomLine6.MMPJ_TOPG_Detail_Line_Topic__c = 'Market Performance';
			MomLine6.MMPJ_TOPG_Comment__c = null;
            insert MomLine6;
            Test.setCurrentPageReference(Page.MMPJ_TOPG_MinutesPDF);
            System.currentPageReference().getParameters().put('EventId', ev.id);
            System.currentPageReference().getParameters().put('MeetingId', meeting.id);
            MMPJ_TOPG_MinutesPDFcontroller Ctrl2 = new MMPJ_TOPG_MinutesPDFcontroller();
			
			
			MMPJ_TOPG_MinuteOfMeeting__c Mom3 = new MMPJ_TOPG_MinuteOfMeeting__c();
            Mom3.MMPJ_TOPG_Meeting__c = meeting.Id;
            Mom3.MMPJ_TOPG_Title__c='Test pdf';
            insert Mom3;
			MMPJ_TOPG_MoMLineItem__c MomLine7 = new MMPJ_TOPG_MoMLineItem__c();
            MomLine7.MMPJ_TOPG_Title__c ='test Line';
            MomLine7.MMPJ_TOPG_MinutesofMeeting__c  = Mom3.id;
			MomLine7.MMPJ_TOPG_IsHighlight__c = false;
			MomLine7.MMPJ_TOPG_TopicPPPP__c = 'Product';
			MomLine7.MMPJ_TOPG_Comment__c = 'Comment';
            insert MomLine7;
            Test.setCurrentPageReference(Page.MMPJ_TOPG_MinutesPDF);
            System.currentPageReference().getParameters().put('EventId', ev.id);
            System.currentPageReference().getParameters().put('MeetingId', meeting.id);
            MMPJ_TOPG_MinutesPDFcontroller Ctrl3 = new MMPJ_TOPG_MinutesPDFcontroller();

            MMPJ_TOPG_MinuteOfMeeting__c Mom4 = new MMPJ_TOPG_MinuteOfMeeting__c();
            Mom4.MMPJ_TOPG_Meeting__c = meeting.Id;
            Mom4.MMPJ_TOPG_Title__c='Test pdf';
            insert Mom4;
            RecordType phaseRT1 = new RecordType(Name='Line Item 4P');
            MMPJ_TOPG_MoMLineItem__c MomLine9 = new MMPJ_TOPG_MoMLineItem__c(RecordType = phaseRT1);
            MomLine9.MMPJ_TOPG_Title__c ='test Line';
            MomLine9.MMPJ_TOPG_MinutesofMeeting__c  = Mom4.id;
            MomLine9.MMPJ_TOPG_IsHighlight__c = false;
            MomLine9.MMPJ_TOPG_TopicPPPP__c = 'Product';
            MomLine9.MMPJ_TOPG_Comment__c = 'Comment';
            MomLine9.MMPJ_TOPG_TopicPPPP__c = 'Topic 4P';
            insert MomLine9;
            Test.setCurrentPageReference(Page.MMPJ_TOPG_MinutesPDF);
            System.currentPageReference().getParameters().put('EventId', ev.id);
            System.currentPageReference().getParameters().put('MeetingId', meeting.id);
            MMPJ_TOPG_MinutesPDFcontroller Ctrl4 = new MMPJ_TOPG_MinutesPDFcontroller();

            MMPJ_TOPG_MinuteOfMeeting__c Mom5 = new MMPJ_TOPG_MinuteOfMeeting__c();
            Mom5.MMPJ_TOPG_Meeting__c = meeting.Id;
            Mom5.MMPJ_TOPG_Title__c='Test pdf';
            insert Mom5;
            RecordType phaseRT2 = new RecordType(Name='Line item Market Performance');
            MMPJ_TOPG_MoMLineItem__c MomLine10 = new MMPJ_TOPG_MoMLineItem__c(RecordType = phaseRT2);
            MomLine10.MMPJ_TOPG_Title__c ='test Line';
            MomLine10.MMPJ_TOPG_MinutesofMeeting__c  = Mom5.id;
            MomLine10.MMPJ_TOPG_IsHighlight__c = false;
            MomLine10.MMPJ_TOPG_TopicPPPP__c = 'Product';
            MomLine10.MMPJ_TOPG_Comment__c = '';
            MomLine10.MMPJ_TOPG_Detail_Line_Topic__c = 'Product';
            insert MomLine10;
            Test.setCurrentPageReference(Page.MMPJ_TOPG_MinutesPDF);
            System.currentPageReference().getParameters().put('EventId', ev.id);
            System.currentPageReference().getParameters().put('MeetingId', meeting.id);
            MMPJ_TOPG_MinutesPDFcontroller Ctrl5 = new MMPJ_TOPG_MinutesPDFcontroller();

            MMPJ_TOPG_MinuteOfMeeting__c Mom6 = new MMPJ_TOPG_MinuteOfMeeting__c();
            Mom6.MMPJ_TOPG_Meeting__c = meeting.Id;
            Mom6.MMPJ_TOPG_Title__c='Test pdf';
            insert Mom6;
            RecordType phaseRT3 = new RecordType(Name='Line item Competitor');
            MMPJ_TOPG_MoMLineItem__c MomLine11 = new MMPJ_TOPG_MoMLineItem__c(RecordType = phaseRT3);
            MomLine11.MMPJ_TOPG_Title__c ='test Line';
            MomLine11.MMPJ_TOPG_MinutesofMeeting__c  = Mom6.id;
            MomLine11.MMPJ_TOPG_IsHighlight__c = false;
            MomLine11.MMPJ_TOPG_TopicPPPP__c = 'Product';
            MomLine11.MMPJ_TOPG_Comment__c = 'Comment';
            MomLine11.MMPJ_TOPG_Competitor__c = null;
            insert MomLine11;
            Test.setCurrentPageReference(Page.MMPJ_TOPG_MinutesPDF);
            System.currentPageReference().getParameters().put('EventId', ev.id);
            System.currentPageReference().getParameters().put('MeetingId', meeting.id);
            MMPJ_TOPG_MinutesPDFcontroller Ctrl6 = new MMPJ_TOPG_MinutesPDFcontroller();

            MMPJ_TOPG_MinuteOfMeeting__c Mom7 = new MMPJ_TOPG_MinuteOfMeeting__c();
            Mom7.MMPJ_TOPG_Meeting__c = meeting.Id;
            Mom7.MMPJ_TOPG_Title__c='Test pdf';
            insert Mom7;
            RecordType phaseRT4 = new RecordType(Name='Line Item Project');
            MMPJ_TOPG_MoMLineItem__c MomLine12 = new MMPJ_TOPG_MoMLineItem__c(RecordType = phaseRT4);
            MomLine12.MMPJ_TOPG_Title__c ='test Line Item Project';
            MomLine12.MMPJ_TOPG_MinutesofMeeting__c  = Mom7.id;
            MomLine12.MMPJ_TOPG_IsHighlight__c = false;
            MomLine12.MMPJ_TOPG_RelatedProject__c = null;
            MomLine12.MMPJ_TOPG_Comment__c = null;
            insert MomLine12;
            Test.setCurrentPageReference(Page.MMPJ_TOPG_MinutesPDF);
            System.currentPageReference().getParameters().put('EventId', ev.id);
            System.currentPageReference().getParameters().put('MeetingId', meeting.id);
            MMPJ_TOPG_MinutesPDFcontroller Ctrl7 = new MMPJ_TOPG_MinutesPDFcontroller();

            MMPJ_TOPG_MinuteOfMeeting__c Mom8 = new MMPJ_TOPG_MinuteOfMeeting__c();
            Mom8.MMPJ_TOPG_Meeting__c = meeting.Id;
            Mom8.MMPJ_TOPG_Title__c='Test pdf';
            insert Mom8;
            RecordType phaseRT5 = new RecordType(Name='Line item Market Performance');
            MMPJ_TOPG_MoMLineItem__c MomLine13 = new MMPJ_TOPG_MoMLineItem__c(RecordType = phaseRT5);
            MomLine13.MMPJ_TOPG_Title__c ='test Line';
            MomLine13.MMPJ_TOPG_MinutesofMeeting__c  = Mom8.id;
            MomLine13.MMPJ_TOPG_IsHighlight__c = false;
            MomLine13.MMPJ_TOPG_TopicPPPP__c = 'Product';
            MomLine13.MMPJ_TOPG_Comment__c = 'Comment for LIMP';
            MomLine13.MMPJ_TOPG_Detail_Line_Topic__c = 'Product';
            insert MomLine13;
            Test.setCurrentPageReference(Page.MMPJ_TOPG_MinutesPDF);
            System.currentPageReference().getParameters().put('EventId', ev.id);
            System.currentPageReference().getParameters().put('MeetingId', meeting.id);
            MMPJ_TOPG_MinutesPDFcontroller Ctrl8 = new MMPJ_TOPG_MinutesPDFcontroller();

        }
    }
}