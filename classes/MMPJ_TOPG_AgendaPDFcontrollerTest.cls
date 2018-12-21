@isTest
public class MMPJ_TOPG_AgendaPDFcontrollerTest
{
    private static  Datetime myDT = Datetime.now();
     private static String  mailPrefix = myDT.format('ddMMyyyy');
    static testMethod void testAgendaPDF()
    {  
        Profile adminProfile= [Select Id From Profile Where Name = 'System Administrator'];
        
        User u = new User(Username = mailPrefix+'-NPLsupervisor@supervisor.com', email = mailPrefix+'-supervisor@supervisor.com', profileID = adminProfile.id, IsActive = true, LastName='Supervisor', Alias='sup', TimeZoneSidKey='GMT', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US');
        insert u;
        User u2 = new User(Username = mailPrefix+'-NPLsuper2visor@supervisor.com', email = mailPrefix+'-super2visor@supervisor.com', profileID = adminProfile.id, IsActive = true, LastName='Supervisor', Alias='sup', TimeZoneSidKey='GMT', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US');
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
            //bmcTest.MMPJ_TOPG_Market__c=market.id;
            //bmcTest.MMPJ_TOPG_Brand__c=brand.id;
            insert bmcTest ;
            
            MMPJ_TOPG_Meeting__c  meeting = new MMPJ_TOPG_Meeting__c ();
            meeting.MMPJ_TOPG_BMC__c = bmcTest.id;
            Meeting.MMPJ_TOPG_Interaction__c = 'test';
            insert meeting;
            
             MMPJ_TOPG_MinuteOfMeeting__c Mom = new MMPJ_TOPG_MinuteOfMeeting__c();
            Mom.MMPJ_TOPG_Meeting__c = meeting.Id;
            mom.MMPJ_TOPG_Title__c='Test pdf';
            insert Mom;
            
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
            MMPJ_TOPG_Project__c ProjectTest = new MMPJ_TOPG_Project__c(name='test Project',MMPJ_TOPG_StartDate__c = Date.parse('2/2/2016'),MMPJ_TOPG_EndDate__c =Date.parse('2/2/2016'));
            insert ProjectTest ;
            MMPJ_TOPG_Competitor__c Competitor = new MMPJ_TOPG_Competitor__c(name = 'test comp');
            insert Competitor;
            MMPJ_TOPG_4P__c PPPP = new MMPJ_TOPG_4P__c(MMPJ_TOPG_Topic__c = 'testtttttttttttttttttttttttttttttttt',name='wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww',MMPJ_TOPG_Meeting__c  = meeting.id);
            MMPJ_TOPG_MeetingCompetitor__c Comp = new MMPJ_TOPG_MeetingCompetitor__c(MMPJ_TOPG_Meeting__c  = meeting.id,MMPJ_TOPG_Competitor__c = Competitor.id);
            MMPJ_TOPG_MeetingMarketPerf__c MarketPerf = new MMPJ_TOPG_MeetingMarketPerf__c(MMPJ_TOPG_Meeting__c = meeting.id,MMPJ_TOPG_FileName__c ='testFile');
            MMPJ_TOPG_MeetingProject__c Project = new MMPJ_TOPG_MeetingProject__c(MMPJ_TOPG_Meeting__c = meeting.id,MMPJ_TOPG_Project__c = ProjectTest.id);
            
            insert PPPP ;
            insert Comp ;
            insert MarketPerf ;
            insert Project ;
            
            Test.setCurrentPageReference(Page.MMPJ_TOPG_AgendaPDF);
            System.currentPageReference().getParameters().put('EventId', ev.id);
            System.currentPageReference().getParameters().put('MeetingId', meeting.id);
            MMPJ_TOPG_AgendaPDFcontroller Ctrl = new MMPJ_TOPG_AgendaPDFcontroller();
         }
    }
}