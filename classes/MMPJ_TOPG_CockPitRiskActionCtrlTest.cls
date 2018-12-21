@isTest
public class MMPJ_TOPG_CockPitRiskActionCtrlTest {
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

            MMPJ_TOPG_BMC__c bmcTest = new MMPJ_TOPG_BMC__c ();
            bmcTest.name='bmcTest';           
            insert bmcTest ;
            
            MMPJ_TOPG_BMC__c allMarket = new MMPJ_TOPG_BMC__c ();
            allMarket.name='All Markets';           
            insert allMarket ;
            
            MMPJ_TOPG_BMC__c france = new MMPJ_TOPG_BMC__c ();
            france.name='France';           
            insert france ;
            
            MMPJ_TOPG_BMC__c japan = new MMPJ_TOPG_BMC__c ();
            japan.name='Japan';           
            insert japan ;

            MMPJ_TOPG_Meeting__c  meeting = new MMPJ_TOPG_Meeting__c ();
            meeting.MMPJ_TOPG_BMC__c = bmcTest.id;
            Meeting.MMPJ_TOPG_Interaction__c = 'test';
            insert meeting;
            
            MMPJ_TOPG_Meeting__c  meetingFrance = new MMPJ_TOPG_Meeting__c ();
            meetingFrance.MMPJ_TOPG_BMC__c = france.id;
            meetingFrance.MMPJ_TOPG_Interaction__c = 'Call';
            insert meetingFrance;
            
             MMPJ_TOPG_Meeting__c  meetingJapan = new MMPJ_TOPG_Meeting__c ();
            meetingJapan.MMPJ_TOPG_BMC__c = japan.id;
            meetingJapan.MMPJ_TOPG_Interaction__c = 'Call';
            insert meetingJapan;

            Event ev = new Event();
            ev.Subject='tet';
            ev.StartDateTime = System.now(); //DateTime.parse('2/2/2016 10:53 AM') ;
            ev.ENDDateTime = System.now(); //DateTime.parse('2/2/2016 10:55 AM');
            ev.Location = 'est';
            ev.Whatid=meetingFrance.id;
            insert ev;
            
            Event ev1 = new Event();
            ev1.Subject='tet';
            ev1.StartDateTime = System.now(); //DateTime.parse('2/2/2016 10:53 AM') ;
            ev1.ENDDateTime = System.now(); //DateTime.parse('2/2/2016 10:55 AM');
            ev1.Location = 'est';
            ev1.Whatid=meetingJapan.id;
            insert ev1;

            eventRelation evRl = new EventRelation();
            evRl.relationid = u2.id;
            evRl.EventId = ev.id;
            insert evRl;
            
            eventRelation evR2 = new EventRelation();
            evR2.relationid = u2.id;
            evR2.EventId = ev1.id;
            insert evR2;

            contact c = new contact();
            c.Lastname = 'test contact';
            insert c;

            eventRelation evRl2 = new EventRelation();
            evRl2.relationid = c.id;
            evRl2.EventId = ev.id;
            insert evRl2;
            
           MMPJ_TOPG_Competitor__c competitor = new  MMPJ_TOPG_Competitor__c();
           competitor.name = 'Overview';
           insert competitor;
            
             //insert project
            MMPJ_TOPG_Project__c project = new MMPJ_TOPG_Project__c();
            project.name = 'testProject';
            project.MMPJ_TOPG_NewProjectType__c = 'Classical Project';
            project.MMPJ_TOPG_StartDate__c= Date.newInstance(2016,11,11);
            project.MMPJ_TOPG_EndDate__c= Date.newInstance(2016,12,12);
            project.MMPJ_TOPG_ProjectOwner__c=u.id; 
            insert project;
            
             MMPJ_TOPG_Project__c project1 = new MMPJ_TOPG_Project__c();
            project1.name = 'testProject';
            project1.MMPJ_TOPG_NewProjectType__c = 'Classical Project';
            project1.MMPJ_TOPG_StartDate__c= Date.newInstance(2016,11,11);
            project1.MMPJ_TOPG_EndDate__c= Date.newInstance(2016,12,12);
            project1.MMPJ_TOPG_ProjectOwner__c=u2.id; 
            insert project1;
            
           
			// MOM
            MMPJ_TOPG_MinuteofMeeting__c min = new MMPJ_TOPG_MinuteofMeeting__c();
            min.MMPJ_TOPG_Start_Date__c=ev.StartDateTime;
            min.MMPJ_TOPG_End_Date__c=ev.ENDDateTime;
            min.MMPJ_TOPG_RAID__c='Action';
            min.MMPJ_TOPG_Title__c='Test tilte';
            min.MMPJ_TOPG_Status__c='Planned';
            min.MMPJ_TOG_MinutesDate__c=system.today();
            min.MMPJ_TOPG_Location__c = ev.Location;           
            min.MMPJ_TOPG_Meeting__c = meetingFrance.id;
            min.MMPJ_TOPG_Assist__c = true;
            insert min;
            
            MMPJ_TOPG_MinuteofMeeting__c min1 = new MMPJ_TOPG_MinuteofMeeting__c();
            min1.MMPJ_TOPG_Start_Date__c=ev.StartDateTime;
            min1.MMPJ_TOPG_End_Date__c=ev.ENDDateTime;
            min1.MMPJ_TOPG_RAID__c='Action';
            min1.MMPJ_TOPG_Title__c='Test tilte';
            min1.MMPJ_TOPG_Status__c='Planned';
            min1.MMPJ_TOG_MinutesDate__c=system.today();
            min1.MMPJ_TOPG_Location__c = ev.Location;           
            min1.MMPJ_TOPG_Meeting__c = meetingJapan.id;
            min1.MMPJ_TOPG_Assist__c = true;
            insert min1;
	
            //Add detail line :Market
            MMPJ_TOPG_MoMLineItem__c LineItemMark = new MMPJ_TOPG_MoMLineItem__c();
           LineItemMark.RecordtypeId=Schema.SObjectType.MMPJ_TOPG_MoMLineItem__c.getRecordTypeInfosByName().get('Line item Market Performance').getRecordTypeId();
           LineItemMark.MMPJ_TOPG_Title__c='Test line Item';
           LineItemMark.MMPJ_TOPG_Detail_Line_Topic__c ='Market Performance';
           LineItemMark.MMPJ_TOPG_FileName__c = 'File or text';
           LineItemMark.MMPJ_TOPG_Comment__c ='Comment line Item';
           LineItemMark.MMPJ_TOPG_RAID__c ='Risk';
           LineItemMark.MMPJ_TOPG_When__c=system.Today();
           LineItemMark.MMPJ_TOPG_MinutesofMeeting__c =min.id;
           LineItemMark.MMPJ_TOPG_RelatedProject__c = project.id;
           insert LineItemMark;
            
           MMPJ_TOPG_MoMLineItem__c LineItemMark1 = new MMPJ_TOPG_MoMLineItem__c();
           LineItemMark1.RecordtypeId=Schema.SObjectType.MMPJ_TOPG_MoMLineItem__c.getRecordTypeInfosByName().get('Line item Market Performance').getRecordTypeId();
           LineItemMark1.MMPJ_TOPG_Title__c='Test line Item';
           LineItemMark1.MMPJ_TOPG_Detail_Line_Topic__c ='Market Performance';
           LineItemMark1.MMPJ_TOPG_FileName__c = 'File or text';
           LineItemMark1.MMPJ_TOPG_Comment__c ='Comment line Item';
           LineItemMark1.MMPJ_TOPG_RAID__c ='Risk';
           LineItemMark1.MMPJ_TOPG_When__c=system.Today();
           LineItemMark1.MMPJ_TOPG_MinutesofMeeting__c =min1.id;
           LineItemMark1.MMPJ_TOPG_RelatedProject__c = project1.id;
           insert LineItemMark1;

            //Add detail line : Competitor
           MMPJ_TOPG_MoMLineItem__c LineItemComp = new MMPJ_TOPG_MoMLineItem__c();
           LineItemComp.RecordtypeId=Schema.SObjectType.MMPJ_TOPG_MoMLineItem__c.getRecordTypeInfosByName().get('Line item Competitor').getRecordTypeId();
           LineItemComp.MMPJ_TOPG_Detail_Line_Topic__c ='Competition';
           LineItemComp.MMPJ_TOPG_Competitor__c=competitor.id;
           LineItemComp.MMPJ_TOPG_Title__c='Test line Item';
           LineItemComp.MMPJ_TOPG_Topic__c ='Test line Item';
           LineItemComp.MMPJ_TOPG_RAID__c ='Risk';
           LineItemComp.MMPJ_TOPG_When__c=system.Today();
           LineItemComp.MMPJ_TOPG_MinutesofMeeting__c =min.id;
           LineItemComp.MMPJ_TOPG_RelatedProject__c = project.id;
           insert LineItemComp;
            
            MMPJ_TOPG_MoMLineItem__c LineItemComp1 = new MMPJ_TOPG_MoMLineItem__c();
           LineItemComp1.RecordtypeId=Schema.SObjectType.MMPJ_TOPG_MoMLineItem__c.getRecordTypeInfosByName().get('Line item Competitor').getRecordTypeId();
           LineItemComp1.MMPJ_TOPG_Detail_Line_Topic__c ='Competition';
           LineItemComp1.MMPJ_TOPG_Competitor__c=competitor.id;
           LineItemComp1.MMPJ_TOPG_Title__c='Test line Item';
           LineItemComp1.MMPJ_TOPG_Topic__c ='Test line Item';
           LineItemComp1.MMPJ_TOPG_RAID__c ='Risk';
           LineItemComp1.MMPJ_TOPG_When__c=system.Today();
           LineItemComp1.MMPJ_TOPG_MinutesofMeeting__c =min1.id;
           LineItemComp1.MMPJ_TOPG_RelatedProject__c = project1.id;
           insert LineItemComp1;
            
            //Add detail line :Project-initiative
           MMPJ_TOPG_MoMLineItem__c LineItemProj = new MMPJ_TOPG_MoMLineItem__c();
           LineItemProj.RecordtypeId=Schema.SObjectType.MMPJ_TOPG_MoMLineItem__c.getRecordTypeInfosByName().get('Line Item Project').getRecordTypeId();
           LineItemProj.MMPJ_TOPG_Detail_Line_Topic__c ='Project-Key Initiative';
           LineItemProj.MMPJ_TOPG_RelatedProject__c=project.id;
           LineItemProj.MMPJ_TOPG_Comment__c ='Comment Project-intiative';
           LineItemMark.MMPJ_TOPG_RAID__c ='Risk';
           LineItemProj.MMPJ_TOPG_When__c=system.Today();
           LineItemProj.MMPJ_TOPG_MinutesofMeeting__c =min.id;
           LineItemProj.MMPJ_TOPG_RelatedProject__c = project.id;
           insert LineItemProj;
            
             //Insert RAID
            MMPJ_TOPG_RAID__c raid = new MMPJ_TOPG_RAID__c();
            raid.MMPJ_TOPG_Title__c = 'raid title';
            raid.MMPJ_TOPG_RAID__c = 'Action';
            raid.MMPJ_TOPG_Description__c = 'Desc raid';
            raid.MMPJ_TOPG_ExpectedDate__c = System.today();
            raid.MMPJ_TOPG_TechStartDate__c = System.today();
            raid.MMPJ_TOPG_TechEndDate__c = System.today().addMonths(+1);
            raid.MMPJ_TOPG_Status__c = 'Planned';
            raid.MMPJ_TOPG_User__c = u.id;
            raid.MMPJ_TOPG_Meeting__c = meeting.id;
            raid.MMPJ_TOPG_LineItem__c = LineItemMark.id;
            insert raid;

           
        }
    }
    static testMethod void testapplySearch()
    {
        Event ev = [select id from Event where Subject='tet'limit 1];
        MMPJ_TOPG_Meeting__c  meeting = [select id from MMPJ_TOPG_Meeting__c where MMPJ_TOPG_Interaction__c = 'test' limit 1];
        MMPJ_TOPG_BMC__c bmcTest = [select id from MMPJ_TOPG_BMC__c where name='bmcTest' limit 1];
        MMPJ_TOPG_MoMLineItem__c LineItemMarket = [select id,MMPJ_TOPG_Detail_Line_Topic__c,MMPJ_TOPG_MinutesofMeeting__c,MMPJ_TOPG_Comment__c from MMPJ_TOPG_MoMLineItem__c where MMPJ_TOPG_Detail_Line_Topic__c ='Market Performance' limit 1];
        MMPJ_TOPG_MoMLineItem__c LineItemComp = [select id,MMPJ_TOPG_Competitor__c,MMPJ_TOPG_MinutesofMeeting__c,MMPJ_TOPG_Comment__c from MMPJ_TOPG_MoMLineItem__c where MMPJ_TOPG_Detail_Line_Topic__c ='Competition' limit 1];
      
       system.debug('#### mailPrefix in SOQL :' +mailPrefix+'-NPLsupervisor@pernod-ricard.com');
        user u = [select id from user where Username =: mailPrefix+'-NPLsupervisor@pernod-ricard.com'];
        MMPJ_TOPG_Project__c project = new MMPJ_TOPG_Project__c();
        
        MMPJ_TOPG_CockPitRiskActionController marketRiskAction = new MMPJ_TOPG_CockPitRiskActionController() ;
        marketRiskAction.Raid = [Select MMPJ_TOPG_Title__c, MMPJ_TOPG_RAID__c,MMPJ_TOPG_Description__c,MMPJ_TOPG_ExpectedDate__c, MMPJ_TOPG_TechStartDate__c,MMPJ_TOPG_TechEndDate__c,
                            MMPJ_TOPG_Status__c,MMPJ_TOPG_User__c,MMPJ_TOPG_Meeting__c,MMPJ_TOPG_LineItem__c from MMPJ_TOPG_RAID__c where MMPJ_TOPG_Title__c = 'raid title' ];
        
        marketRiskAction.StartDate = System.today();
		marketRiskAction.EndDate = System.today().addMonths(+1);  
        
        //Test with no selected market
         Test.startTest();        
         marketRiskAction.applySearch();        
       
       
        //Test with All Markets      
        
         MMPJ_TOPG_BMC__c bmcAllMarkets = [select id, Name from MMPJ_TOPG_BMC__c where name='All Markets' limit 1];
         marketRiskAction.SelectedMarkets.add(new SelectOption(bmcAllMarkets.Name, bmcAllMarkets.Name));
         marketRiskAction.applySearch(); 
       
        
        //Test With selected Markets
        marketRiskAction.SelectedMarkets.clear();
        for(MMPJ_TOPG_BMC__c bmc : [SELECT Name FROM MMPJ_TOPG_BMC__c  where name !='All Markets' order by name asc]){
             marketRiskAction.SelectedMarkets.add(new SelectOption(bmc.Name, bmc.Name));
        }
        
         marketRiskAction.applySearch(); 
       
        Test.stopTest();

    }
}